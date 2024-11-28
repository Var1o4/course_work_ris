package com.example.course_like_erip.dto;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.xml.bind.annotation.*;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import lombok.Data;

@XmlRootElement(name = "payments")
@XmlAccessorType(XmlAccessType.NONE)
@Data
public class PaymentXmlDTO {

    @XmlElement(name = "payment")
    private List<PaymentEntry> payments;

    @XmlAccessorType(XmlAccessType.NONE)
    @Data
    public static class PaymentEntry {
        @XmlElement(required = true)
        private String name;
        
        @XmlElement(required = true)
        private String description;
        
        @XmlElement(required = true)
        private Double amount;
        
        @XmlElement(name = "userEmail", required = true)
        private String userEmail;
        
        @XmlElement(name = "dueDate", required = true)
        @XmlJavaTypeAdapter(LocalDateTimeAdapter.class)
        private LocalDateTime dueDate;
    }
}

