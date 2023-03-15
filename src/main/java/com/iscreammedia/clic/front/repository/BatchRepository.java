package com.iscreammedia.clic.front.repository;

import com.iscreammedia.clic.front.domain.BatchLog;

import org.springframework.stereotype.Repository;

@Repository
public interface BatchRepository {

	public void insertBatchErrorLog(BatchLog param);
}