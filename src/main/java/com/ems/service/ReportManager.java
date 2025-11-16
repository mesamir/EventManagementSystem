package com.ems.service;

import com.ems.dao.*;

import com.ems.util.DateUtils;

import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.Date;


public class ReportManager {
    private final EventDAO eventDAO;
    private final VendorDAO vendorDAO;
    private final PaymentDAO paymentDAO;

    public ReportManager() {
        this.eventDAO = new EventDAO();
        this.vendorDAO = new VendorDAO();
        this.paymentDAO = new PaymentDAO();
    }

    public List<?> getReportData(String reportType, String timeFilter, String statusFilter) throws SQLException {
        // Convert the string time filter into a java.util.Date here.
        Date filterDate = DateUtils.getDateFromFilter(timeFilter);
        
        switch (reportType) {
            case "financial_report":
                return Collections.emptyList(); // Placeholder

            case "event_summary_report":
            case "full_event_report":
                return eventDAO.getFilteredEvents(filterDate, statusFilter);

            case "vendor_performance_report":
                return vendorDAO.getVendorPerformance(
                    filterDate != null ? new java.sql.Date(filterDate.getTime()) : null
                );

            case "full_vendor_report":
                return vendorDAO.getFilteredVendors(filterDate, statusFilter);

            case "full_payments_report":
                return paymentDAO.getFilteredPayments(
                    filterDate != null ? new java.sql.Date(filterDate.getTime()) : null,
                    statusFilter
                );

            default:
                throw new IllegalArgumentException("Invalid report type.");
                }
            }
    }