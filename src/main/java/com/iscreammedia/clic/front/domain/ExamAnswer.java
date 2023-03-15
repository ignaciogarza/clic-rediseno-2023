package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExamAnswer {
	private Integer   questionId;     // 문항 아이디
	private Integer   examProgressId; // 자가/기술 시험 진헹 아이디
	private String    isAnswer;       // 정답 여부
	private String    shortAnswer;    // 주관식 답변
	private Integer[] exampleAnswer = new Integer[5];  // 객관식 / 선긋기 / 척도 답변

	private String userId;

	public void setExampleAnswer(int[] exampleAnswer) {
		for(int i = 0; i < exampleAnswer.length; i++) {
			this.exampleAnswer[i] = exampleAnswer[i];
		}
	}

	public void setExampleAnswer1(int exampleAnswer1) {
		this.exampleAnswer[0] = exampleAnswer1;
	}

	public void setExampleAnswer2(int exampleAnswer2) {
		this.exampleAnswer[1] = exampleAnswer2;
	}

	public void setExampleAnswer3(int exampleAnswer3) {
		this.exampleAnswer[2] = exampleAnswer3;
	}

	public void setExampleAnswer4(int exampleAnswer4) {
		this.exampleAnswer[3] = exampleAnswer4;
	}

	public void setExampleAnswer5(int exampleAnswer5) {
		this.exampleAnswer[4] = exampleAnswer5;
	}
}
