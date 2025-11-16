<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vendor Profile Management</title>
    <!-- Include your CSS files here -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7f9;
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">

    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-2xl mx-4 my-8">
        <h1 class="text-3xl font-bold text-center text-gray-800 mb-6">
            <c:if test="${vendorProfile != null}">Edit Your Vendor Profile</c:if>
            <c:if test="${vendorProfile == null}">Create Your Vendor Profile</c:if>
        </h1>
        
        <!-- Display info/error messages -->
        <c:if test="${not empty param.infoMessage}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4" role="alert">
                <span class="block sm:inline">${param.infoMessage}</span>
            </div>
        </c:if>
        <c:if test="${not empty param.errorMessage}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                <span class="block sm:inline">${param.errorMessage}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/vendor/profile" method="post" class="space-y-6">
            
            <!-- Hidden fields for userId and vendorId -->
            <c:set var="loggedInUser" value="${sessionScope.loggedInUser}" />
            <input type="hidden" name="userId" value="${loggedInUser.userId}">
            <c:if test="${vendorProfile != null}">
                <input type="hidden" name="vendorId" value="${vendorProfile.vendorId}">
            </c:if>

            <div>
                <label for="companyName" class="block text-sm font-medium text-gray-700">Company Name</label>
                <input type="text" id="companyName" name="companyName" value="${vendorProfile.companyName}" required
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
            </div>

            <div>
                <label for="serviceType" class="block text-sm font-medium text-gray-700">Service Type</label>
                <input type="text" id="serviceType" name="serviceType" value="${vendorProfile.serviceType}" required
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
            </div>
            
            <div>
                <label for="contactPerson" class="block text-sm font-medium text-gray-700">Contact Person</label>
                <input type="text" id="contactPerson" name="contactPerson" value="${vendorProfile.contactPerson}" required
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
            </div>

            <div>
                <label for="phone" class="block text-sm font-medium text-gray-700">Phone Number</label>
                <input type="tel" id="phone" name="phone" value="${vendorProfile.phone}" required
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
            </div>

            <div>
                <label for="email" class="block text-sm font-medium text-gray-700">Contact Email</label>
                <input type="email" id="email" name="email" value="${vendorProfile.email}" required
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
            </div>

            <div>
                <label for="address" class="block text-sm font-medium text-gray-700">Address</label>
                <input type="text" id="address" name="address" value="${vendorProfile.address}"
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
            </div>

            <div>
                <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
                <textarea id="description" name="description" rows="4"
                          class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">${vendorProfile.description}</textarea>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label for="minPrice" class="block text-sm font-medium text-gray-700">Min Price ($)</label>
                    <input type="number" step="0.01" id="minPrice" name="minPrice" value="${vendorProfile.minPrice}"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                </div>
                <div>
                    <label for="maxPrice" class="block text-sm font-medium text-gray-700">Max Price ($)</label>
                    <input type="number" step="0.01" id="maxPrice" name="maxPrice" value="${vendorProfile.maxPrice}"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                </div>
            </div>

            <div>
                <label for="portfolioLink" class="block text-sm font-medium text-gray-700">Portfolio Link</label>
                <input type="url" id="portfolioLink" name="portfolioLink" value="${vendorProfile.portfolioLink}"
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
            </div>

            <div class="flex justify-end">
                <button type="submit"
                        class="w-full inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    <c:if test="${vendorProfile != null}">Update Profile</c:if>
                    <c:if test="${vendorProfile == null}">Create Profile</c:if>
                </button>
            </div>
        </form>
    </div>
</body>
</html>
