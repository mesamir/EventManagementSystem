<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${page.title} - EMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
    <!-- Header -->
    <header class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center py-4">
                <div class="flex items-center">
                    <a href="${pageContext.request.contextPath}/" class="text-xl font-bold text-blue-600">
                        Event Management System
                    </a>
                </div>
                <nav class="flex space-x-4">
                    <a href="${pageContext.request.contextPath}/" class="text-gray-600 hover:text-gray-900">Home</a>
                    <a href="${pageContext.request.contextPath}/pages" class="text-gray-600 hover:text-gray-900">All Pages</a>
                    <a href="${pageContext.request.contextPath}/admin/cms/pages" class="text-gray-600 hover:text-gray-900">Admin</a>
                </nav>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
        <article class="bg-white rounded-lg shadow-md overflow-hidden">
            <div class="p-8">
                <h1 class="text-3xl font-bold text-gray-900 mb-4">${page.title}</h1>
                
                <!-- Page Meta -->
                <div class="flex items-center text-sm text-gray-500 mb-6">
                    <span class="mr-4">Last updated: 
                        <fmt:formatDate value="${page.updatedAt}" pattern="MMM dd, yyyy"/>
                    </span>
                    <span class="px-2 py-1 text-xs font-medium rounded-full 
                        <c:choose>
                            <c:when test="${page.status == 'PUBLISHED'}">bg-green-100 text-green-800</c:when>
                            <c:when test="${page.status == 'DRAFT'}">bg-yellow-100 text-yellow-800</c:when>
                            <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                        </c:choose>">
                        ${page.status}
                    </span>
                </div>

                <!-- Page Content -->
                <div class="prose max-w-none">
                    ${page.content}
                </div>
            </div>
        </article>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t mt-12">
        <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
            <p class="text-center text-gray-500 text-sm">
                &copy; 2024 Event Management System. All rights reserved.
            </p>
        </div>
    </footer>
</body>
</html>