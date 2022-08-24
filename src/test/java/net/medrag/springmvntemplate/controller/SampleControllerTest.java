package net.medrag.springmvntemplate.controller;

import net.medrag.springmvntemplate.service.SampleService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.verifyNoMoreInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SampleControllerTest {
    @Mock
    private SampleService sampleService;
    @InjectMocks
    private SampleController sampleController;

    @Test
    @DisplayName("must return OK value")
    void test1() {
        // given
        when(sampleService.getString()).thenReturn("OK");

        // when
        final var result = sampleController.info();

        // then
        assertAll(
            () -> assertEquals("OK", result, "TemplateService invocation must return OK"),
            () -> verifyNoMoreInteractions(sampleService)
        );
    }

    @Test
    @DisplayName("must throw exception")
    void testException() {
        // given
        when(sampleService.getString()).thenThrow(new RuntimeException("oops"));

        // when
        assertThrows(RuntimeException.class, () -> sampleController.info(), "RuntimeException must be thrown");

        // then
        assertAll(
            () -> verifyNoMoreInteractions(sampleService)
        );
    }

}