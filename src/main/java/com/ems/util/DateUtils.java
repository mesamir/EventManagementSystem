// src/main/java/com/ems/util/DateUtils.java
package com.ems.util;

import java.util.Calendar;
import java.util.Date;

public class DateUtils {
    public static Date getDateFromFilter(String timeFilter) {
        if (timeFilter == null || "all_time".equalsIgnoreCase(timeFilter)) {
            return null;
        }

        Calendar cal = Calendar.getInstance();
        if ("last_7_days".equalsIgnoreCase(timeFilter)) {
            cal.add(Calendar.DATE, -7);
        } else if ("last_30_days".equalsIgnoreCase(timeFilter)) {
            cal.add(Calendar.DATE, -30);
        } else if ("last_quarter".equalsIgnoreCase(timeFilter)) {
            cal.add(Calendar.MONTH, -3);
        } else if ("last_year".equalsIgnoreCase(timeFilter)) {
            cal.add(Calendar.YEAR, -1);
        }
        return cal.getTime();
    }
}
