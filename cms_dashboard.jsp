<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>EMS CMS Dashboard</title>
    <link rel="stylesheet" href="/assets/css/style.css">
</head>
<body>
    <h2>EMS CMS Dashboard</h2>
    <p>Welcome to the content management system. Choose a module below:</p>

    <ul>
        <li><a href="<%= request.getContextPath() %>/admin/cms/pages">Manage Pages</a></li>
        <li><a href="<%= request.getContextPath() %>/admin/cms/banners">Manage Banners</a></li>
        <li><a href="<%= request.getContextPath() %>/admin/cms/blocks">Manage Content Blocks</a></li>
        <li><a href="<%= request.getContextPath() %>/admin/cms/vendor">Vendor CMS</a></li>
        <li><a href="<%= request.getContextPath() %>/admin/cms/templates">Event Templates</a></li>
        <li><a href="<%= request.getContextPath() %>/admin/cms/seo">SEO Manager</a></li>
        <li><a href="<%= request.getContextPath() %>/admin/cms/social">Social Links</a></li>
    </ul>
</body>
</html>

