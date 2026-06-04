package com.campusconveniencestore.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public final class Sha256Utils {

    private Sha256Utils() {
    }

    public static String sha256(String text) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashed = digest.digest(text.getBytes(StandardCharsets.UTF_8));
            StringBuilder builder = new StringBuilder();
            for (byte value : hashed) {
                String hex = Integer.toHexString(value & 0xff);
                if (hex.length() == 1) {
                    builder.append('0');
                }
                builder.append(hex);
            }
            return builder.toString();
        } catch (Exception exception) {
            throw new IllegalStateException("SHA-256 计算失败", exception);
        }
    }
}
