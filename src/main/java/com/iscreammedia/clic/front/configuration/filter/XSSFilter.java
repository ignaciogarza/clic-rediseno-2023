package com.iscreammedia.clic.front.configuration.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public class XSSFilter implements Filter {

	@SuppressWarnings("unused")
	private FilterConfig filterConfig;

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		this.filterConfig = filterConfig;
	}

	@Override
	public void destroy() {
		this.filterConfig = null;
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		chain.doFilter(new RequestWrapper((HttpServletRequest) request), response);

	}

	public final class RequestWrapper extends HttpServletRequestWrapper {

		public RequestWrapper(HttpServletRequest servletRequest) {
			super(servletRequest);
		}

		public String[] getParameterValues(String parameter) {

			String[] values = super.getParameterValues(parameter);
			if(values == null) {
				return values;
			}
			int count = values.length;
			String[] encodedValues = new String[count];
			for(int i = 0; i < count; i++) {
				encodedValues[i] = cleanXSS(values[i]);
			}
			return encodedValues;
		}

		public String getParameter(String parameter) {
			String value = super.getParameter(parameter);
			if(value == null) {
				return null;
			}
			return cleanXSS(value);
		}
		@Override
		public String getHeader(String name) {
			String value = super.getHeader(name);
			if(value == null)
				return null;
			return cleanXSS(value);

		}

		private String cleanXSS(String value) {
			// You'll need to remove the spaces from the html entities below
			value = value.replace("<", "&lt;").replace(">", "&gt;");
			value = value.replace("\\(", "&#40;").replace("\\)", "&#41;");
			value = value.replace("\"", "&#34;").replace("'", "&#39;");
			value = value.replace("eval\\((.*)\\)", "");
			value = value.replace("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
			value = value.replace("script", "");
			return value;
		}
	}
}