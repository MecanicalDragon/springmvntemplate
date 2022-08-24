package net.medrag.springmvntemplate.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * @author Stanislav Tretyakov
 * 08.08.2022
 */
@Slf4j
@Service
public class SampleService {
    public String getString() {
        log.info("String is requested.");
        return "OK";
    }
}
