package com.iscreammedia.clic.front.configuration;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.iscreammedia.clic.front.domain.BaseCodeLabelEnum;

public class BaseCodeLabelEnumJsonSerializer extends JsonSerializer<BaseCodeLabelEnum>{

	@Override
	public void serialize(BaseCodeLabelEnum value, JsonGenerator gen, SerializerProvider serializers)
			throws IOException {
		Map<String, Object> map = new HashMap<>();
		map.put("code", value.code());
		map.put("label", value.label());
		gen.writeObject(map);
	}

}
