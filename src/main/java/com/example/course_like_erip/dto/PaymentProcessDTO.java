package com.example.course_like_erip.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class PaymentProcessDTO {
    private Long paymentId;
    private Long invoiceId;
    private BigDecimal amount;
}