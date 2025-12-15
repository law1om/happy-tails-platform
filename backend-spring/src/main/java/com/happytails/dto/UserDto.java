package com.happytails.dto;

import com.happytails.entity.User;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDto {
    private Long id;
    private String fullName;
    private String email;
    private String phone;
    private User.Role role;
    private User.UserStatus status;
    private LocalDateTime createdAt;
}
