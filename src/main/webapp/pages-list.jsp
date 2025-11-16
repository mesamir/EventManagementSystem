<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Pages - EMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
    <header class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center py-4">
                <a href="${pageContext.request.contextPath}/" class="text-xl font-bold text-blue-600">
                    Event Management System
                </a>
                <nav class="flex space-x-4">
                    <a href="${pageContext.request.contextPath}/" class="text-gray-600 hover:text-gray-900">Home</a>
                    <a href="${pageContext.request.contextPath}/admin/cms/pages" class="text-gray-600 hover:text-gray-900">Admin</a>
                </nav>
            </div>
        </div>
    </header>

    <main class="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Published Pages</h1>
        
        <c:choose>
            <c:when test="${not empty publishedPages}">
                <div class="grid gap-6">
                    <c:forEach var="page" items="${publishedPages}">
                        <div class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">
                            <h2 class="text-xl font-semibold text-gray-900 mb-2">
                                <a href="${pageContext.request.contextPath}/pages/${page.slug}" 
                                   class="hover:text-blue-600">
                                    ${page.title}
                                </a>
                            </h2>
                            <p class="text-gray-600 mb-4">
                                <code class="text-sm bg-gray-100 px-2 py-1 rounded">/${page.slug}</code>
                            </p>
                            <div class="text-sm text-gray-500">
                                Last updated: <fmt:formatDate value="${page.updatedAt}" pattern="MMM dd, yyyy"/>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-12">
                    <p class="text-gray-500 text-lg">No published pages available.</p>
                    <a href="${pageContext.request.contextPath}/admin/cms/pages" 
                       class="inline-block mt-4 bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700">
                        Create a Page
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</body>
</html>
