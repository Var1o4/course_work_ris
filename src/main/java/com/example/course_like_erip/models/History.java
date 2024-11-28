package com.example.course_like_erip.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.example.course_like_erip.models.Enum.ActionType;
import com.example.course_like_erip.models.Enum.InvoiceStatus;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Entity
@Table(name = "history")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class History {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "history_id")
    private Long historyId;

    @Column(name = "table_name", nullable = false)
    private String tableName;

    @Column(name = "old_values", columnDefinition = "TEXT")
    private String oldValues;
    
    @Column(name = "new_values", columnDefinition = "TEXT")
    private String newValues;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "changed_by", nullable = false)
    private User changedBy;

    @Column(name = "changed_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime changedAt;

    @Column(name = "changed_fields", nullable = false)
    private String changedFields;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "action_type", nullable = false, length = 20)
    private ActionType actionType;
    
    @Column(name = "entity_id")
    private Long entityId;
    
    @Column(name = "ip_address")
    private String ipAddress;
    
    @Column(name = "user_agent")
    private String userAgent;
    
    @PrePersist
    protected void onCreate() {
        changedAt = LocalDateTime.now();
    }
} 