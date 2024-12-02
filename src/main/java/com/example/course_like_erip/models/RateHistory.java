package com.example.course_like_erip.models;

import java.time.LocalDate;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class RateHistory {
    private LocalDate Date;
    private Double Cur_OfficialRate;
} 