package com.example.course_like_erip.dto;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class MonthlyExpenseDTO {
    private String month;
    private BigDecimal amount;
    private String formattedMonth;
} 