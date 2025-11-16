<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Use EL to safely access the Event Type/Title from the Event object -->
    <title>RSVP: ${event.type != null ? event.type : 'Event Invitation'}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        .status-message {
            padding: 1rem;
            border-radius: 0.5rem;
            font-weight: 600;
        }
        .status-message.success {
            background-color: #f0fdf4; /* Green 50 */
            color: #166534; /* Green 800 */
            border: 1px solid #bbf7d0; /* Green 200 */
        }
        .status-message.error {
            background-color: #fef2f2; /* Red 50 */
            color: #b91c1c; /* Red 700 */
            border: 1px solid #fecaca; /* Red 300 */
        }
        .rsvp-card {
            background-color: white;
            padding: 2.5rem;
            border-radius: 1.5rem; /* More rounded corners */
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            max-width: 500px;
            width: 100%;
        }
        .form-input {
             /* Use standard Tailwind classes for input styling */
             @apply mt-1 block w-full px-4 py-3 text-base border-gray-300 focus:outline-none focus:ring-pink-500 focus:border-pink-500 sm:text-lg rounded-xl shadow-sm transition duration-150;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-indigo-100 to-pink-100 min-h-screen flex items-center justify-center p-4">

    <!-- 
        By using Expression Language (EL), we retrieve the Java objects 
        set by RsvpServlet (guestManager.getGuestById(guestId)).
    -->
    <c:set var="guest" value="${requestScope.guest}" />
    <c:set var="event" value="${requestScope.event}" />
    <c:set var="messageType" value="${requestScope.messageType}" />
    <c:set var="messageText" value="${requestScope.messageText}" />
    
    <%-- Fallback for display if objects are missing --%>
    <c:set var="eventTitle" value="${event.type != null ? event.type : 'Your Special Event'}" />
    <c:set var="guestName" value="${guest.name != null ? guest.name : 'Esteemed Guest'}" />
    
    <!-- Link is valid if both objects were successfully fetched by the servlet -->
    <c:set var="isValidLink" value="${guest != null && event != null}" />

    <div class="rsvp-card transform hover:scale-[1.01] transition duration-300">
        
        <h1 class="text-4xl font-extrabold text-pink-600 mb-2 tracking-tight">You're Invited!</h1>
        <h2 class="text-2xl text-gray-700 mb-8 font-semibold">${eventTitle}</h2>
        
        <p class="text-gray-600 mb-8 border-b pb-4 text-lg">
            Dear <span class="font-bold text-gray-900">${guestName}</span>, please confirm your attendance.
        </p>
        
        <!-- Display Event Details -->
        <div class="mb-8 space-y-3 text-gray-700 p-5 bg-indigo-50 rounded-xl border border-indigo-200">
            <h3 class="font-bold text-indigo-700 text-lg">Event Details</h3>
            <!-- FORMAT DATE for beautiful display -->
            <p class="text-sm"><span class="font-semibold text-indigo-800">Date & Time:</span> 
                <fmt:formatDate value="${event.date}" pattern="EEEE, MMMM d, yyyy 'at' h:mm a" />
            </p>
            <p class="text-sm"><span class="font-semibold text-indigo-800">Location:</span> ${event.location}</p>
            
            <p class="text-sm pt-2"><span class="font-semibold text-indigo-800">Current RSVP:</span> 
                <span class="text-md font-bold ${guest.rsvpStatus eq 'Confirmed' ? 'text-green-600' : (guest.rsvpStatus eq 'Declined' ? 'text-red-600' : 'text-yellow-600')}">
                    ${guest.rsvpStatus}
                </span>
            </p>
        </div>

        <c:choose>
            <c:when test="${!isValidLink}">
                <!-- Error scenario: Objects not found by servlet -->
                <div class="status-message error border-red-400">
                    The invitation link is invalid or the event/guest record was not found. Please contact the event organizer.
                </div>
            </c:when>
            <c:otherwise>
                <!-- Display Status Message (After Submission) -->
                <c:if test="${messageText != null && !messageText.isEmpty()}">
                    <div class="status-message ${messageType}">
                        ${messageText}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/rsvpServlet" method="POST" class="space-y-6 mt-6">
                    
                    <!-- Hidden fields for IDs -->
                    <input type="hidden" name="eventID" value="${event.eventId}">
                    <input type="hidden" name="guestID" value="${guest.guestId}">

                    <div>
                        <label for="rsvp_status" class="block text-sm font-medium text-gray-700 mb-2">Will you be attending?</label>
                        <select id="rsvp_status" name="rsvp_status" required class="form-input text-gray-800">
                            <option value="" disabled 
                                <c:if test="${guest.rsvpStatus eq 'Pending' || guest.rsvpStatus == null}">selected</c:if>>
                                -- Select Response --
                            </option>
                            <option value="Confirmed" 
                                <c:if test="${guest.rsvpStatus eq 'Confirmed'}">selected</c:if>>
                                Yes, I will attend 🎉
                            </option>
                            <option value="Declined" 
                                <c:if test="${guest.rsvpStatus eq 'Declined'}">selected</c:if>>
                                No, I cannot make it 😔
                            </option>
                        </select>
                    </div>

                    <div>
                        <label for="comment" class="block text-sm font-medium text-gray-700 mb-2">Message for the Host (Optional)</label>
                        <textarea id="comment" name="comment" rows="3" placeholder="Dietary restrictions, best wishes, etc."
                                  class="form-input text-gray-800"></textarea>
                    </div>

                    <button type="submit"
                            class="w-full flex justify-center py-4 px-4 border border-transparent rounded-xl shadow-lg text-xl font-semibold text-white 
                                   bg-pink-600 hover:bg-pink-700 transition-all duration-300 ease-in-out transform hover:scale-[1.02] 
                                   focus:outline-none focus:ring-4 focus:ring-pink-500 focus:ring-opacity-50">
                        Submit RSVP
                    </button>
                </form>
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>
