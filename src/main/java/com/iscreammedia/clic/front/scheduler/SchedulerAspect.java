package com.iscreammedia.clic.front.scheduler;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.iscreammedia.clic.front.domain.BatchLog;
import com.iscreammedia.clic.front.repository.BatchRepository;

import lombok.extern.slf4j.Slf4j;

@Component
@Aspect
@Slf4j
public class SchedulerAspect {

	@Autowired
	private BatchRepository batchRepository;
	
	private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");

	private Date startDate;

	// @Pointcut("execution(public void com.iscreammedia.clic.front.scheduler.*.*())")
	@Pointcut("@annotation(org.springframework.scheduling.annotation.Scheduled)")
	private void pointcut() {log.info("pointcut start");}

	@After("pointcut()")
	public void after(JoinPoint joinPoint) {
		String jobName = getJobName(joinPoint);
		long total = new Date().getTime() - startDate.getTime();
		log.info("== {} : {} : {}ms END ===========================================================", jobName, startDate.getTime(), total);
		unlock(jobName);
	}

	@AfterThrowing(pointcut = "pointcut()", throwing = "e")
	public void afterThrowing(JoinPoint joinPoint, Exception e) {
		String jobName = getJobName(joinPoint);
		Date endDate = new Date();
		long total = endDate.getTime() - startDate.getTime();

		StringWriter sw = new StringWriter();
		e.printStackTrace(new PrintWriter(sw));
		batchRepository.insertBatchErrorLog(new BatchLog(jobName, startDate, endDate, total, sw.toString()));
		unlock(jobName);
	}

	@Around("pointcut()")
	public void around(ProceedingJoinPoint joinPoint) throws Throwable {		
			startDate = new Date();
			String jobName = getJobName(joinPoint);
			log.info("== {} : {} START ===========================================================", jobName,
					startDate.getTime());
			if (isUnlock(jobName)) {
				lock(jobName);
				joinPoint.proceed();
			} 		
	}

	private String getJobName(JoinPoint joinPoint) {
		return joinPoint.getSignature().toShortString();
	}

	private boolean isUnlock(String jobName) {
		//String value = stringRedisTemplate.opsForValue().get(jobName);
		String value = "";
		log.info("== isUnlock : {} : {}", jobName, value);
		return StringUtils.isEmpty(value);
	}

	private void lock(String jobName) {
		//stringRedisTemplate.opsForValue().set(jobName, dateFormat.format(startDate));
	}

	private void unlock(String jobName) {
		//stringRedisTemplate.expire(jobName, -1, TimeUnit.SECONDS);
	}
}
