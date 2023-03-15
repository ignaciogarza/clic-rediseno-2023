package com.iscreammedia.clic.front.configuration.filter;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;

import javax.servlet.FilterChain;
import javax.servlet.ReadListener;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.data.annotation.Id;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.CommonsRequestLoggingFilter;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class RequestLoggingFilter extends CommonsRequestLoggingFilter {
	@Override
	protected void doFilterInternal(HttpServletRequest request, final HttpServletResponse response,
			final FilterChain filterChain)
			throws ServletException, IOException {

		final boolean isFirstRequest = !isAsyncDispatch(request);

		// for logging json request data
		if (isFirstRequest) {
			if (isJsonContentType(request)) {
				request = new LoggingRequestWrapper(request);
			}

			if (!isResource(request)) {
				loggingRequest(request);
			}
		}

		filterChain.doFilter(request, response);
	}

	private boolean isResource(final HttpServletRequest request) {

		String[] excludePaths = { "/static/", "/resources/", "/upload/", "/favicon.ico", "/" };
		String[] excludeExts = { ".icon", ".png", ".gif", ".jpg", ".jpeg", ".bmp" };

		boolean check = false;
		for (String path : excludePaths) {
			if (request.getRequestURI().startsWith(path)) {
				check = true;
			}
		}

		if (!check) {
			for (String ext : excludeExts) {
				if (request.getRequestURI().endsWith(ext)) {
					check = true;
				}
			}
		}

		return check;
	}

	private boolean isJsonContentType(final HttpServletRequest request) {
		final String contentType = request.getContentType();
		if (contentType == null) {
			return false;
		} else {
			try {
				final MediaType mediaType = MediaType.parseMediaType(contentType);
				return MediaType.APPLICATION_JSON.includes(mediaType);
			} catch (IllegalArgumentException ex) {
				return false;
			}
		}
	}

	@Override
	protected void beforeRequest(HttpServletRequest request, String message) {

		loggingRequest(request);
	}

	private void loggingRequest(final HttpServletRequest request) {

		StringBuilder sb = new StringBuilder();

		// client ip
		final String client = request.getRemoteAddr();
		sb.append(client);

		// method
		String method = request.getMethod();
		sb.append(" [").append(method).append("] ");

		// request uri
		sb.append(request.getRequestURI());

		log.info(sb.toString());

		// header
		Enumeration<String> headerNames = request.getHeaderNames();
		if (headerNames != null) {
			log.info("####################### Headers ####################################");
			while (headerNames.hasMoreElements()) {
				String key = headerNames.nextElement();
				log.info("{} : {}", (String) key, request.getHeader(key));
			}
			log.info("###############################################################");
		}

		// parameter
		final Map<String, String[]> parameterMap = sortRequestParameters(request);
		if (!parameterMap.isEmpty()) {
			log.info("####################### Parameters #################################");

			for (final Entry<String, String[]> entry : parameterMap.entrySet()) {
				final String key = entry.getKey();
				final String[] value = entry.getValue();

				sb = new StringBuilder();
				sb.append(key);
				for (int i = 0; i < 30 - key.length(); i++) {
					sb.append(' ');
				}
				if (key.contains("pass")) {
					sb.append("[********]");
				} else {
					sb.append(Arrays.deepToString(value));
				}

				log.info(sb.toString());
			}

			log.info("####################################################################");
		}

		// json body
		if (request instanceof LoggingRequestWrapper) {
			log.info("####################### Request Body ###############################");
			try {
				LoggingRequestWrapper wrapper = new LoggingRequestWrapper(request);
				log.info(wrapper.toString());
			} catch (IOException e) {
				e.getMessage();
			}
			log.info("####################################################################");
		}
	}

	private Map<String, String[]> sortRequestParameters(final HttpServletRequest request) {
		final TreeMap<String, String[]> sortedParams = new TreeMap<>();
		final Set<Entry<String, String[]>> params = request.getParameterMap().entrySet();
		for (final Entry<String, String[]> entry : params) {
			sortedParams.put(entry.getKey(), entry.getValue());
		}
		return sortedParams;
	}

	public class HttpLoggingWrapper extends HttpServletRequestWrapper {
		public HttpLoggingWrapper(HttpServletRequest request) {
			super(request);
		}

		private String getBodyAsString() {
			StringBuilder buff = new StringBuilder();
			char[] charArr = new char[getContentLength()];

			try (BufferedReader reader = new BufferedReader(getReader());) {
				reader.read(charArr, 0, charArr.length);

			} catch (IOException e) {
				e.getMessage();
			}
			buff.append(charArr);
			return buff.toString();
		}

		public String toString() {
			return getBodyAsString();
		}
	}

	private class LoggingRequestWrapper extends HttpServletRequestWrapper {

		private final Charset encoding;
		private final byte[] rawData;

		public LoggingRequestWrapper(HttpServletRequest request) throws IOException {
			super(request);

			String characterEncoding = request.getCharacterEncoding();
			if (StringUtils.isEmpty(characterEncoding)) {
				characterEncoding = StandardCharsets.UTF_8.name();
			}
			this.encoding = Charset.forName(characterEncoding);

			InputStream inputStream = request.getInputStream();
			this.rawData = IOUtils.toByteArray(inputStream);
		}

		@Override
		public ServletInputStream getInputStream() throws IOException {
			final ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(this.rawData);
			ServletInputStream servletInputStream = new ServletInputStream() {
				@Override
				public int read() throws IOException {
					return byteArrayInputStream.read();
				}

				@Override
				public boolean isFinished() {
					return false;
				}

				@Override
				public boolean isReady() {
					return false;
				}

				@Override
				public void setReadListener(ReadListener listener) {
					throw new UnsupportedOperationException();
				}
			};
			log.info("servletInputStream: {}", servletInputStream);
			return servletInputStream;
		}

		@Override
		public BufferedReader getReader() throws IOException {
			return new BufferedReader(new InputStreamReader(this.getInputStream(), this.encoding));
		}

		@Id
		@Override
		public ServletRequest getRequest() {
			return super.getRequest();
		}

		public String toString() {

			return new String(rawData, encoding);
		}
	}
}
