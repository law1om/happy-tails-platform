package com.happytails.config;

import com.happytails.entity.User;
import com.happytails.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    
    @Override
    public void run(String... args) {
        initializeAdmin();
        initializeTestUser();
    }
    
    private void initializeAdmin() {
        User admin = userRepository.findByEmail("admin@happytails.com")
                .orElse(null);
        
        if (admin == null) {
            // Создаем нового админа
            admin = User.builder()
                    .fullName("Администратор")
                    .email("admin@happytails.com")
                    .password(passwordEncoder.encode("admin123"))
                    .phone("+7 777 999-99-99")
                    .role(User.Role.ADMIN)
                    .status(User.UserStatus.ACTIVE)
                    .build();
            
            userRepository.save(admin);
            log.info("Admin user created: admin@happytails.com / admin123");
        } else {
            // Обновляем пароль существующего админа, если он не соответствует дефолтному dev-паролю
            String currentPassword = admin.getPassword();
            if (currentPassword == null || !passwordEncoder.matches("admin123", currentPassword)) {
                admin.setPassword(passwordEncoder.encode("admin123"));
                admin.setRole(User.Role.ADMIN);
                admin.setStatus(User.UserStatus.ACTIVE);
                userRepository.save(admin);
                log.info("Admin password set to default and re-hashed: admin@happytails.com / admin123");
            } else {
                log.info("Admin user already exists with correct password");
            }
        }
    }
    
    private void initializeTestUser() {
        User user = userRepository.findByEmail("ramil@tails.com")
                .orElse(null);
        
        if (user == null) {
            // Создаем нового пользователя
            user = User.builder()
                    .fullName("Тестовый Пользователь")
                    .email("ramil@tails.com")
                    .password(passwordEncoder.encode("123123"))
                    .phone("+7 777 123-45-67")
                    .role(User.Role.USER)
                    .status(User.UserStatus.ACTIVE)
                    .build();
            
            userRepository.save(user);
            log.info("Test user created: ramil@tails.com / 123123");
        } else {
            // Обновляем пароль существующего пользователя, если он не соответствует дефолтному dev-паролю
            String currentPassword = user.getPassword();
            if (currentPassword == null || !passwordEncoder.matches("123123", currentPassword)) {
                user.setPassword(passwordEncoder.encode("123123"));
                user.setRole(User.Role.USER);
                user.setStatus(User.UserStatus.ACTIVE);
                userRepository.save(user);
                log.info("Test user password set to default and re-hashed: ramil@tails.com / 123123");
            } else {
                log.info("Test user already exists with correct password");
            }
        }
    }
}
