package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExamExample {
	private Integer exampleId;               // 보기 아이디
	private Integer questionId;              // 문항 아이디
	private Integer exampleNumber;           // 보기 번호
	private String  exampleContents;         // 보기 내용
	private String  exampleImagePath;        // 보기 이미지 경로
	private String  isAnswer;                // 정답 여부
	private Integer lineDrawingAnswerNumber; // 선긋기 정답 번호
}
