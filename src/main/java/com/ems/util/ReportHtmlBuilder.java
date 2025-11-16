// src/main/java/com/ems/util/ReportHtmlBuilder.java
package com.ems.util;

import com.ems.model.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Utility class to build HTML tables for different report types.
 * This keeps the presentation logic out of the servlet.
 */
public class ReportHtmlBuilder {

    // Simple utility for formatting dates
    private static String formatDate(Date date) {
        if (date == null) {
            return "";
        }
        return new SimpleDateFormat("yyyy-MM-dd").format(date);
    }

    // Simple utility for formatting currency
    private static String formatCurrency(double amount) {
        DecimalFormat formatter = new DecimalFormat("#,##0.00");
        return "$" + formatter.format(amount);
    }
    
    public static String buildHtmlTable(String reportType, List<?> data) {
        if (data == null || data.isEmpty()) {
            return "<div class='text-center p-8'><p class='text-gray-500'>No data found for this report and filter combination.</p></div>";
        }

        StringBuilder html = new StringBuilder();
        html.append("<h3 class='text-2xl font-bold mb-4 capitalize'>").append(reportType.replace('_', ' ')).append(" Report</h3>");

        // Start table
        html.append("<div class='overflow-x-auto'><table class='min-w-full divide-y divide-gray-200 shadow-sm rounded-lg'>")
            .append("<thead class='bg-gray-50'><tr>");

        // Build table headers based on report type
        switch (reportType) {
            case "event_summary_report":
            case "full_event_report":
                html.append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Event ID</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Event Name</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Event Date</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Status</th></tr></thead><tbody class='bg-white divide-y divide-gray-200'>");
                for (Object item : data) {
                    Event event = (Event) item;
                    html.append("<tr>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900'>").append(event.getEventId()).append("</td>")
                       // .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(event.getEventName()).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(formatDate(event.getDate())).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(event.getStatus()).append("</td>")
                        .append("</tr>");
                }
                break;
            case "full_vendor_report":
                html.append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Vendor ID</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Vendor Name</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Contact Person</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Registration Date</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Status</th></tr></thead><tbody class='bg-white divide-y divide-gray-200'>");
                for (Object item : data) {
                    Vendor vendor = (Vendor) item;
                    html.append("<tr>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900'>").append(vendor.getVendorId()).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(vendor.getCompanyName()).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(vendor.getContactPerson()).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(vendor.getRegistrationDate()).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(vendor.getStatus()).append("</td>")
                        .append("</tr>");
                }
                break;
            case "vendor_performance_report":
                html.append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Vendor Name</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Total Events</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Total Revenue</th></tr></thead><tbody class='bg-white divide-y divide-gray-200'>");
                for (Object item : data) {
                    // Assuming a custom model like VendorPerformanceReport
                    VendorPerformance report = (VendorPerformance) item;
                    html.append("<tr>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(report.getVendorName()).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(report.getTotalEvents()).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(formatCurrency(report.getTotalRevenue())).append("</td>")
                        .append("</tr>");
                }
                break;
            case "full_payments_report":
                html.append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Payment ID</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Booking ID</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Amount</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Payment Date</th>")
                    .append("<th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Status</th></tr></thead><tbody class='bg-white divide-y divide-gray-200'>");
                for (Object item : data) {
                    Payment payment = (Payment) item;
                    html.append("<tr>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900'>").append(payment.getPaymentId()).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(payment.getBookingId()).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(payment.getAmount()).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(payment.getPaymentDate()).append("</td>")
                        .append("<td class='px-6 py-4 whitespace-nowrap text-sm text-gray-500'>").append(payment.getStatus()).append("</td>")
                        .append("</tr>");
                }
                break;
            default:
                return "<p class='text-red-500'>Report template not found.</p>";
        }

        // Close table
        html.append("</tbody></table></div>");
        return html.toString();
    }
}