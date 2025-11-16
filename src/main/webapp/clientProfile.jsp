<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        .form-input { @apply w-full px-4 py-3 border border-gray-300 rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500; }
    </style>
</head>
<body class="bg-gray-50 p-6 sm:p-10">
    <c:set var="client" value="${requestScope.clientProfile}" />
    <c:set var="user" value="${requestScope.loggedInUser}" />

    <div class="max-w-4xl mx-auto bg-white rounded-xl shadow-2xl p-6 sm:p-10">
        <h1 class="text-3xl font-bold text-gray-800 mb-6">My Profile</h1>
        <form action="${pageContext.request.contextPath}/client/profile" method="POST" class="space-y-6">
            <input type="hidden" name="clientId" value="${client.customerId}" />
            <div>
                <label class="block text-sm font-medium text-gray-700">Full Name</label>
                <input type="text" name="name" value="${user.name}" class="form-input" readonly />
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Email</label>
                <input type="email" name="email" value="${user.email}" class="form-input bg-gray-100" readonly />
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Phone</label>
                <input type="tel" name="phone" value="${client.phone}" class="form-input" />
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Address</label>
                <textarea name="address" rows="3" class="form-input">${client.address}</textarea>
            </div>
            <button type="submit" class="bg-indigo-600 text-white px-6 py-3 rounded-lg hover:bg-indigo-700">Save Changes</button>
        </form>
    </div>
</body>
</html>
