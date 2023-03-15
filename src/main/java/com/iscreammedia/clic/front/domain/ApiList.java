package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class ApiList<T> {
	private int     totalCount;
	private List<T> dataList;
}
