package com.example.course_like_erip.models.Enum;

public enum InvoiceStatus {
  ACTIVE("Активен"),
  FROZEN("Заморожен"),
  ARRESTED("Арестован"),
  DELETED("Удалён");

  private final String displayName;

  InvoiceStatus(String displayName) {
      this.displayName = displayName;
  }

  public String getDisplayName() {
      return displayName;
  }
}