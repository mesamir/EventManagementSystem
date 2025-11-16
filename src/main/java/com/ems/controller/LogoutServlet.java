    // src/main/java/com/ems/controller/LogoutServlet.java
    package com.ems.controller;

    import java.io.IOException;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import jakarta.servlet.http.HttpSession;

    @WebServlet("/logout") // Maps this servlet to /logout
    public class LogoutServlet extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false); // Do not create a new session if one doesn't exist

            if (session != null) {
                session.invalidate(); // Invalidate the current session
                System.out.println("User session invalidated."); // For debugging
            } else {
                System.out.println("No active session to invalidate."); // For debugging
            }

            // Redirect to the login page or home page after logout
            response.sendRedirect(request.getContextPath() + "/login.jsp?logoutSuccess=true");
        }

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            // Typically, logout is a GET request, but handle POST for robustness
            doGet(request, response);
        }
    }
    