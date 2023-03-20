package com.johnesleyer.QRApp3;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;

@Configuration
public class WebConfiguration extends WebMvcConfigurationSupport {

    @Value("${image.directory}")
    private String uploadFolderPath;

    @Override
    protected void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry
            .addResourceHandler("/**") 
            .addResourceLocations("file:" + uploadFolderPath);
    }
}