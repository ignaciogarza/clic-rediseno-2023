package com.iscreammedia.clic.front.domain;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Date;

import lombok.Getter;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Getter
@ToString
public class BatchLog {
	private Integer batchId;
	private String  serverName;
	private String  jobName;
	private Date    jobStartDate;
	private Date    jobEndDate;
	private Long    jobTime;
	private String  errorLog;

	public BatchLog(String jobName, Date jobStartDate, Date jobEndDate, long jobTime, String errorLog) {
		try {
			this.serverName = InetAddress.getLocalHost().getHostName();
		}
		catch(UnknownHostException e) {
			try {
				this.serverName = InetAddress.getLocalHost().getHostAddress();
			}
			catch(UnknownHostException e1) {
				log.info("exception: {}", e1);
			}
		}
		this.jobName = jobName;
		this.jobStartDate = jobStartDate;
		this.jobEndDate = jobEndDate;
		this.jobTime = jobTime;
		this.errorLog = errorLog;
	}
}
