package com.example.course_like_erip.models.Enum;

import org.springframework.security.core.GrantedAuthority;

public enum Role implements GrantedAuthority {
    ROLE_USER, ROLE_URFACE, ROLE_ADMIN;

    @Override
    public String getAuthority() {
        return name();
    }
}
