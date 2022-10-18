<%@page import="java.io.*"%><% 
  String pers = request.getParameter("pers");
  String cmd = request.getParameter("cmd");
  String id = request.getParameter("idnt");

  String path = "/usr/java/tomcat/webapps/hunters/ROOT/fileupload/PS3/AOTF/";
  File mask = new File(path, "Mask_" + pers + ".png");
  long ms = mask.exists() ? mask.length() : 0;
  File thumb = new File(path, "Thumb_" + pers + ".png");
  long ts = thumb.exists() ? thumb.length() : 0;
  
  if ("dir".equalsIgnoreCase(cmd)) {
	response.setContentType("text/xml");
	
	boolean both = ms != 0 && ts != 0;

	%><?xml version="1.0" encoding="UTF-8"?>
<LOCKER error="0" game="/ps3/ao3" maxBytes="104857600" maxFiles="64" numBytes="<%=ms + ts%>" numFiles="<%=both ? 2 : 0%>" ownr="100000000" pers="<%=pers%>"><% if (both) { %>
<FILE attr="12" date="1308998863" desc="FULL|PNG|0|1910|0" game="/ps3/ao3" idnt="60000001" locs="<%=ms%>" name="8af888d82fd5c62f0130c6697fbf4acd" perm="7" size="<%=ms%>" type="" vers="0"/>
<FILE attr="12" date="1308998863" desc="THUMB|PNG|0|1910|0" game="/ps3/ao3" idnt="60000002" locs="<%=ts%>" name="8af888d82fd5c62f0130c6697fbf4acd" perm="7" size="<%=ts%>" type="" vers="0"/><% } %>
</LOCKER><% }
  else if ("get".equalsIgnoreCase(cmd)) {
	  File file = null;
	  if ("60000001".equals(id)) file = mask;
	  else if ("60000002".equals(id)) file = thumb;
	  else
		  out.write("ID " + id + " not found");
	  if (file != null) {
		try {
			FileInputStream in = new FileInputStream(file);
			try {
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				byte[] buff = new byte[16384];
				int read;
				while ((read = in.read(buff)) != -1) {
				  if (read != 0)
					baos.write(buff, 0, read);
				}
				response.setContentType("application/octet-stream");
				response.setContentLength(baos.size());
				response.setHeader("Pragma", "no-cache");
				response.setHeader("Cache-Control", "no-cache");
				response.setDateHeader("Expires", 0);
				baos.writeTo(response.getOutputStream());
				baos.flush();
			} finally {
			  in.close();
			}
		} catch(Exception e) {
			out.write("Error: " + e.getMessage());
		}
	  }
  }
%>