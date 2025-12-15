package com.happytails.service;

import com.happytails.dto.UserDto;
import com.happytails.dto.request.LoginRequest;
import com.happytails.dto.request.RegisterRequest;
import com.happytails.dto.response.AuthResponse;
import com.happytails.entity.User;
import com.happytails.exception.BadRequestException;
import com.happytails.mapper.UserMapper;
import com.happytails.repository.UserRepository;
import com.happytails.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider tokenProvider;
    private final UserMapper userMapper;
    
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("Email already in use");
        }
        
        User user = User.builder()
                .fullName(request.getFullName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .phone(request.getPhone())
                .role(User.Role.USER)
                .status(User.UserStatus.ACTIVE)
                .build();
        
        user = userRepository.save(user);
        
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );
        
        String token = tokenProvider.generateToken(authentication);
        String refreshToken = tokenProvider.generateRefreshToken(user.getId());
        
        UserDto userDto = userMapper.toDto(user);
        
        return AuthResponse.builder()
                .token(token)
                .refreshToken(refreshToken)
                .user(userDto)
                .build();
    }
    
    public AuthResponse login(LoginRequest request) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
            );
            String token = tokenProvider.generateToken(authentication);
            User user = userRepository.findByEmail(request.getEmail())
                    .orElseThrow(() -> new BadRequestException("User not found"));
            String refreshToken = tokenProvider.generateRefreshToken(user.getId());
            UserDto userDto = userMapper.toDto(user);
            return AuthResponse.builder()
                    .token(token)
                    .refreshToken(refreshToken)
                    .user(userDto)
                    .build();
        } catch (BadCredentialsException ex) {
            // Graceful recovery: if the stored password is plain text and equals the provided one, re-hash and retry
            User user = userRepository.findByEmail(request.getEmail())
                    .orElseThrow(() -> new BadRequestException("Invalid email or password"));
            String stored = user.getPassword();
            boolean looksBcrypt = stored != null && (stored.startsWith("$2a$") || stored.startsWith("$2b$"));
            if (stored != null && !looksBcrypt && stored.equals(request.getPassword())) {
                user.setPassword(passwordEncoder.encode(request.getPassword()));
                userRepository.save(user);
                // Retry authentication after fixing hash
                Authentication authentication = authenticationManager.authenticate(
                        new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
                );
                String token = tokenProvider.generateToken(authentication);
                String refreshToken = tokenProvider.generateRefreshToken(user.getId());
                UserDto userDto = userMapper.toDto(user);
                return AuthResponse.builder()
                        .token(token)
                        .refreshToken(refreshToken)
                        .user(userDto)
                        .build();
            }
            throw new BadRequestException("Invalid email or password");
        }
    }
}
