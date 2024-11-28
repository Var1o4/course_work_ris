package com.example.course_like_erip.models.Enum;

public enum ActionType {
    CREATE("Создание"),
    UPDATE("Редактирование"),
    DELETE("Удаление"),
    LOGIN("Вход в систему"),
    LOGOUT("Выход из системы"),
    PAYMENT("Оплата"),
    TRANSFER("Перевод"),
    STATUS_CHANGE("Изменение статуса"),
    VERIFICATION("Верификация"),
    BAN("Блокировка");

    private final String description;

    ActionType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
} 