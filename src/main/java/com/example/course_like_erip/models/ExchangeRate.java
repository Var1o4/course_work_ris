package com.example.course_like_erip.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class ExchangeRate {
    private Integer Cur_ID;
    
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime Date;
    
    private String Cur_Abbreviation;
    private Integer Cur_Scale;
    private String Cur_Name;
    private BigDecimal Cur_OfficialRate;
}



