<%@page import="org.apache.commons.lang.StringEscapeUtils,org.apache.commons.fileupload.*,org.apache.commons.fileupload.disk.*"%><%!
%><%@page import="org.apache.commons.fileupload.servlet.*,java.awt.*,java.awt.image.*,java.io.*,java.util.List,javax.imageio.*"%><%!
  static final int MAX_UPLOAD_SIZE = 10 * 1024 * 1024;
  static final int UPLOAD_THRESHOLD = 10 * 1024;
  static final FileItemFactory fif = new DiskFileItemFactory(UPLOAD_THRESHOLD, null);
%><%
  ServletFileUpload upload = new ServletFileUpload(fif);
  upload.setSizeMax(MAX_UPLOAD_SIZE);
  List<FileItem> items = upload.parseRequest(request);
  
  String game = null, user = null, desc = "Nothing Happened";
  FileItem file = null;
  for (FileItem item: items) {
	if (item.isFormField()) {
	  String name = item.getFieldName();
	  if ("game".equals(name)) game = item.getString().trim();
	  else if ("user".equals(name)) user = item.getString().trim();
      item.delete();
    }
	else
	  file = item;
  }
  
  if (file != null) {
	if ("AOTF".equals(game)) 
	  try {
		String path = "/usr/java/tomcat/webapps/hunters/ROOT/fileupload/PS3/AOTF/";
		BufferedImage image = ImageIO.read(file.getInputStream());
		// out.write("Image " + image.getWidth() + "x" + image.getHeight() + " => 512x512<br>");
		Image img = image.getScaledInstance(512, 512, Image.SCALE_SMOOTH);
		BufferedImage bi = new BufferedImage(512, 512, BufferedImage.TYPE_INT_ARGB);
		Graphics2D g2d = bi.createGraphics();
		g2d.drawImage(img, 0, 0, null);
		g2d.dispose();
		// Dispose of original img && image ??
		ImageIO.write(bi, "png", new File(path, "Mask_" + user + ".png"));
		img = image.getScaledInstance(32, 32, Image.SCALE_SMOOTH);
		bi = new BufferedImage(32, 32, BufferedImage.TYPE_INT_ARGB);
		g2d = bi.createGraphics();
		g2d.drawImage(img, 0, 0, null);
		g2d.dispose();
		ImageIO.write(bi, "png", new File(path, "Thumb_" + user + ".png"));
		desc = "<br>Army of Two - The 40th Day mask sucessfully uploaded.<br><br><img src=\"/fileupload/PS3/AOTF/Mask_" + user + ".png\"><br><br>" +
		   "Set your DNS to point easo.ea.com at 110.232.114.67 and run the game.<br><br><a href=\"/DNSconfig.jsp\">For more information click here</a><br>";
	  } catch(Exception e) {
		  out.write("Cannot process Image: " + e.getMesssage());
		  return;
	  }
  }
%><html><head><title>Trophy Hunters - File Upload</title></head><style>body { font-family: "Arial"; font-size: "2em"}</style>
<body>
Trophy Hunters - File Upload<br><br>
Game: <%=StringEscapeUtils.escapeHTML(game)%><br>
User: <%=StringEscapeUtils.escapeHTML(user)%><br>
<%=desc%><br><br>
<a href="/">Back to Main Menu</a>
</body></html>