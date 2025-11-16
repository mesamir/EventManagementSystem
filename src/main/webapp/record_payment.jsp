<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Record Payment - EMS Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-grey);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
        }
        .form-container {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }
        .form-card {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            max-width: 600px;
            width: 100%;
            text-align: center;
        }
        .form-card h2 {
            font-size: 2.2em;
            color: var(--secondary-color);
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }
        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group input[type="datetime-local"],
        .form-group select {
            width: calc(100% - 20px);
            padding: 12px 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
            transition: border-color 0.3s ease;
        }
        .form-group input:focus,
        .form-group select:focus {
            border-color: var(--primary-color);
            outline: none;
        }
        .btn-submit {
            background-color: var(--primary-color);
            color: #fff;
            padding: 15px 30px;
            border: none;
            border-radius: 5px;
            font-size: 1.1em;
            cursor: pointer;
            transition: background-color 0.3s ease;
            width: 100%;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background-color: var(--secondary-color);
        }
        .back-link {
            display: block;
            margin-top: 20px;
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .status-message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: bold;
            text-align: center;
        }
        .status-message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status-message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .booking-summary {
            background-color: #f0f8ff;
            border: 1px solid #cceeff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            text-align: left;
        }
        .booking-summary p {
            margin: 5px 0;
            font-size: 1.05em;
            color: #333;
        }
        .booking-summary p strong {
            color: var(--secondary-color);
            margin-right: 5px;
        }
        .error-message {
            color: #dc3545;
            font-size: 0.85em;
            margin-top: 5px;
            display: block;
            text-align: left;
        }
        input.invalid, select.invalid, textarea.invalid {
            border-color: #dc3545;
        }
        .currency-note {
            font-size: 0.85em;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <!-- Header Section -->
    <header>
        <nav class="navbar">
            <div class="logo">EMS</div>
            <ul class="nav-links">
                <li><a href="<%= request.getContextPath() %>/admin/dashboard">Admin Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/logout">Logout</a></li>
            </ul>
        </nav>
    </header>

    <div class="form-container">
        <div class="form-card">
            <h2>Record Payment for Booking</h2>

            <c:if test="${not empty errorMessage}">
                <div class="status-message error">
                    <c:out value="${errorMessage}" escapeXml="false" />
                </div>
            </c:if>

            <c:if test="${not empty successMessage}">
                <div class="status-message success">
                    <c:out value="${successMessage}" escapeXml="false" />
                </div>
            </c:if>

            <c:if test="${empty booking}">
                <p>Please provide a valid Booking ID to record a payment.</p>
                <form action="<%= request.getContextPath() %>/admin/payment" method="GET">
                    <div class="form-group">
                        <label for="bookingIdInput">Enter Booking ID:</label>
                        <input type="number" id="bookingIdInput" name="bookingId" required min="1">
                    </div>
                    <button type="submit" class="btn-submit">Load Booking</button>
                </form>
            </c:if>

            <c:if test="${not empty booking}">
                <div class="booking-summary">
                    <h3>Booking Summary</h3>
                    <p><strong>Booking ID:</strong> <c:out value="${booking.bookingId}" /></p>
                    <p><strong>Event ID:</strong> <c:out value="${booking.eventId}" /></p>
                    <p><strong>Event Type:</strong> <c:out value="${booking.event.type}" /></p>
                    <p><strong>Client:</strong> <c:out value="${booking.client.name}" /> (<c:out value="${booking.client.email}" />)</p>
                    <p><strong>Vendor ID:</strong> <c:out value="${booking.vendorId}" /></p>
                    <p><strong>Service Booked:</strong> <c:out value="${booking.serviceBooked}" /></p>
                    <p><strong>Booking Amount:</strong> NPR <c:out value="${booking.amount}" /></p>
                    <p><strong>Current Status:</strong> <c:out value="${booking.status}" /></p>
                </div>

                <!-- CHANGED: Updated form action to use the correct servlet mapping -->
                <form id="paymentForm" action="<%= request.getContextPath() %>/admin/processPayment" method="POST" novalidate>
                    <input type="hidden" name="action" value="recordPayment">
                    <input type="hidden" name="bookingId" value="${booking.bookingId}">

                    <div class="form-group">
                        <label for="paymentAmount">Payment Amount (USD):</label>
                        <input type="number" id="paymentAmount" name="paymentAmount" step="0.01" min="0.01"
                               value="<c:out value="${param.paymentAmount != null ? param.paymentAmount : ''}" />" required>
                        <span class="currency-note">Note: Payments are processed in USD for online compatibility</span>
                        <span class="error-message" id="paymentAmountError"></span>
                    </div>

                    <div class="form-group">
                        <label for="paymentDate">Payment Date & Time:</label>
                        <input type="datetime-local" id="paymentDate" name="paymentDate"
                               value="<c:out value="${param.paymentDate != null ? param.paymentDate : ''}" />" required>
                        <span class="error-message" id="paymentDateError"></span>
                    </div>

                    <div class="form-group">
                        <label for="paymentMethod">Payment Method:</label>
                        <select id="paymentMethod" name="paymentMethod" required>
                            <option value="">-- Select Method --</option>
                            <option value="Cash" <c:if test="${param.paymentMethod eq 'Cash'}">selected</c:if>>Cash</option>
                            <option value="Bank Transfer" <c:if test="${param.paymentMethod eq 'Bank Transfer'}">selected</c:if>>Bank Transfer</option>
                            <option value="Card" <c:if test="${param.paymentMethod eq 'Card'}">selected</c:if>>Card</option>
                            <option value="Cheque" <c:if test="${param.paymentMethod eq 'Cheque'}">selected</c:if>>Cheque</option>
                            <option value="Other" <c:if test="${param.paymentMethod eq 'Other'}">selected</c:if>>Other</option>
                        </select>
                        <span class="error-message" id="paymentMethodError"></span>
                    </div>

                    <div class="form-group">
                        <label for="transactionId">Transaction ID (Optional):</label>
                        <input type="text" id="transactionId" name="transactionId"
                               value="<c:out value="${param.transactionId != null ? param.transactionId : ''}" />"
                               placeholder="Leave blank to auto-generate">
                        <span class="error-message" id="transactionIdError"></span>
                    </div>

                    <!-- CHANGED: Updated to use paymentType instead of paymentStatus -->
                    <div class="form-group">
                        <label for="paymentType">Payment Type:</label>
                        <select id="paymentType" name="paymentType" required>
                            <option value="">-- Select Payment Type --</option>
                            <option value="advance" <c:if test="${param.paymentType eq 'advance'}">selected</c:if>>Advance Payment</option>
                            <option value="full" <c:if test="${param.paymentType eq 'full'}">selected</c:if>>Full Payment</option>
                            <option value="balance" <c:if test="${param.paymentType eq 'balance'}">selected</c:if>>Balance Payment</option>
                        </select>
                        <span class="error-message" id="paymentTypeError"></span>
                    </div>

                    <button type="submit" class="btn-submit"><i class="fas fa-money-check-alt"></i> Record Payment</button>
                </form>
            </c:if>

            <a href="<%= request.getContextPath() %>/admin/dashboard#bookings" class="back-link"><i class="fas fa-arrow-left"></i> Back to Booking Management</a>
        </div>
    </div>

    <!-- Footer Section -->
    <footer>
        <div class="footer-bottom">
            &copy; 2025 EMS. All Rights Reserved.
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const paymentForm = document.getElementById('paymentForm');
            if (paymentForm) {
                const paymentAmountInput = document.getElementById('paymentAmount');
                const paymentDateInput = document.getElementById('paymentDate');
                const paymentMethodInput = document.getElementById('paymentMethod');
                const paymentTypeInput = document.getElementById('paymentType');

                const paymentAmountError = document.getElementById('paymentAmountError');
                const paymentDateError = document.getElementById('paymentDateError');
                const paymentMethodError = document.getElementById('paymentMethodError');
                const paymentTypeError = document.getElementById('paymentTypeError');

                function showError(element, message, errorSpan) {
                    errorSpan.textContent = message;
                    element.classList.add('invalid');
                }

                function clearError(element, errorSpan) {
                    errorSpan.textContent = '';
                    element.classList.remove('invalid');
                }

                paymentForm.addEventListener('submit', function(event) {
                    let isValid = true;

                    // Clear all previous errors
                    document.querySelectorAll('.error-message').forEach(span => span.textContent = '');
                    document.querySelectorAll('input, select').forEach(input => input.classList.remove('invalid'));

                    // Validate Payment Amount
                    if (paymentAmountInput.value.trim() === '') {
                        showError(paymentAmountInput, 'Payment Amount is required.', paymentAmountError);
                        isValid = false;
                    } else if (parseFloat(paymentAmountInput.value) <= 0) {
                        showError(paymentAmountInput, 'Amount must be a positive number.', paymentAmountError);
                        isValid = false;
                    }

                    // Validate Payment Date & Time
                    if (paymentDateInput.value.trim() === '') {
                        showError(paymentDateInput, 'Payment Date & Time is required.', paymentDateError);
                        isValid = false;
                    }

                    // Validate Payment Method
                    if (paymentMethodInput.value === '') {
                        showError(paymentMethodInput, 'Payment Method is required.', paymentMethodError);
                        isValid = false;
                    }

                    // Validate Payment Type
                    if (paymentTypeInput.value === '') {
                        showError(paymentTypeInput, 'Payment Type is required.', paymentTypeError);
                        isValid = false;
                    }

                    if (!isValid) {
                        event.preventDefault();
                    }
                });

                // Real-time validation feedback
                paymentAmountInput.addEventListener('input', () => {
                    if (paymentAmountInput.value.trim() !== '' && parseFloat(paymentAmountInput.value) > 0) {
                        clearError(paymentAmountInput, paymentAmountError);
                    }
                });
                paymentDateInput.addEventListener('input', () => { 
                    if (paymentDateInput.value.trim() !== '') clearError(paymentDateInput, paymentDateError); 
                });
                paymentMethodInput.addEventListener('change', () => { 
                    if (paymentMethodInput.value !== '') clearError(paymentMethodInput, paymentMethodError); 
                });
                paymentTypeInput.addEventListener('change', () => { 
                    if (paymentTypeInput.value !== '') clearError(paymentTypeInput, paymentTypeError); 
                });
            }
        });
    </script>
</body>
</html>