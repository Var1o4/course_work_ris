package com.example.course_like_erip.models.Enum;

public enum OperationType {
    DEPOSIT("Пополнение"),
    WITHDRAWAL("Снятие"),
    PAYMENT("Оплата"),
    TRANSFER("Перевод");
    
    private final String description;
    
    OperationType(String description) {
        this.description = description;
    }
    
    public String getDescription() {
        return description;
    }
}