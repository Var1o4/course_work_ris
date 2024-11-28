package com.example.course_like_erip.services;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import com.example.course_like_erip.models.History;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.ActionType;
import com.example.course_like_erip.repositories.HistoryRepository;

import java.util.List;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Slf4j
public class HistoryService {
    private final HistoryRepository historyRepository;

    public List<History> getUserHistory(User user) {
        log.info("Getting history for user: {}", user.getEmail());
        return historyRepository.findByChangedByOrderByChangedAtDesc(user);
    }

    public void saveHistory(String tableName, String oldValues, String newValues, 
                          User user, String changedFields, ActionType actionType, 
                          Long entityId, String ipAddress, String userAgent) {
        History history = History.builder()
                .tableName(tableName)
                .oldValues(oldValues)
                .newValues(newValues)
                .changedBy(user)
                .changedFields(changedFields)
                .actionType(actionType)
                .entityId(entityId)
                .ipAddress(ipAddress)
                .userAgent(userAgent)
                .build();
        historyRepository.save(history);
        log.info("History saved for user: {}, action: {}", user.getEmail(), actionType);
    }

    public List<History> getHistoryByPeriod(User user, LocalDateTime startDate) {
        if (startDate == null) {
            return getUserHistory(user);
        }
        return historyRepository.findByChangedByAndChangedAtAfterOrderByChangedAtDesc(user, startDate);
    }

} 