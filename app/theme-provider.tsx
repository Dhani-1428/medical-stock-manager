'use client'

import React, { createContext, useContext, useEffect, useState, ReactNode } from 'react'

type Theme = 'light' | 'dark' | 'system'

interface ThemeContextType {
  theme: Theme
  setTheme: (theme: Theme) => void
  isDark: boolean
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined)

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [mounted, setMounted] = useState(false)
  const [theme, setThemeState] = useState<Theme>('system')
  const [isDark, setIsDark] = useState(false)

  // Initialize theme once on mount - safely handle SSR
  useEffect(() => {
    // Guard against SSR - only run on client
    if (typeof window === 'undefined') return

    try {
      const stored = localStorage.getItem('theme') as Theme | null
      const initialTheme = stored || 'system'
      
      setThemeState(initialTheme)
      
      // Determine if dark mode based on theme or system preference
      const shouldBeDark = initialTheme === 'dark' || 
        (initialTheme === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches)
      
      setIsDark(shouldBeDark)
      
      if (shouldBeDark) {
        document.documentElement.classList.add('dark')
      } else {
        document.documentElement.classList.remove('dark')
      }
      
      setMounted(true)
    } catch (error) {
      // Fallback if localStorage or window APIs fail
      console.error('Theme initialization error:', error)
      setMounted(true)
    }
  }, [])

  // Update DOM when theme changes
  useEffect(() => {
    if (!mounted || typeof window === 'undefined') return

    try {
      const currentTheme = theme === 'system' 
        ? (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
        : theme

      const shouldBeDark = currentTheme === 'dark'
      setIsDark(shouldBeDark)
      
      if (shouldBeDark) {
        document.documentElement.classList.add('dark')
      } else {
        document.documentElement.classList.remove('dark')
      }

      localStorage.setItem('theme', theme)
    } catch (error) {
      console.error('Theme update error:', error)
    }
  }, [theme, mounted])

  // Listen for system theme changes when in system mode
  useEffect(() => {
    if (theme !== 'system' || !mounted || typeof window === 'undefined') return

    try {
      const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
      
      const handleChange = (e: MediaQueryListEvent) => {
        setIsDark(e.matches)
        if (e.matches) {
          document.documentElement.classList.add('dark')
        } else {
          document.documentElement.classList.remove('dark')
        }
      }

      mediaQuery.addEventListener('change', handleChange)
      return () => mediaQuery.removeEventListener('change', handleChange)
    } catch (error) {
      console.error('Media query setup error:', error)
    }
  }, [theme, mounted])

  const setTheme = (newTheme: Theme) => {
    setThemeState(newTheme)
  }

  // Return provider with current values while mounting
  return (
    <ThemeContext.Provider value={{ theme, setTheme, isDark }}>
      {children}
    </ThemeContext.Provider>
  )
}

export function useTheme() {
  const context = useContext(ThemeContext)
  if (context === undefined) {
    throw new Error('useTheme must be used within a ThemeProvider')
  }
  return context
}
