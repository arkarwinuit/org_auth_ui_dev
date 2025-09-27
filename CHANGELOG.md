# Changelog

All notable changes to this project will be documented in this file.

## [0.0.3] (2025-09-26)

### Added
- **SignUpData Model**: Introduced comprehensive SignUpData model to encapsulate all sign-up information into a single, clean class
- **Enhanced KYC Validation**: Implemented comprehensive NRC and passport number validation with specific format requirements
- **Real-time Form Validation**: Added real-time validation for all sign-up fields with immediate user feedback
- **NRC Format Validation**: Added strict 6-digit NRC number validation with input restrictions
- **Passport Format Validation**: Implemented complex passport number format validation with regex patterns
- **Comprehensive Documentation**: Added complete SignUpPage documentation including API reference, validation details, and usage examples
- **Dynamic Region Loading**: Enhanced NRC region dropdown to dynamically populate based on selected prefix
- **KYC Type Integration**: Improved validation logic to properly handle NRC vs Passport type switching

### Changed
- **Refactored SignUpPage Callback**: Updated onSubmit callback signature from individual parameters to single SignUpData object for better maintainability
- **Updated OrgAuthFlow**: Modified default implementation to use new SignUpData model
- **Enhanced Error Messages**: Improved validation error messages for better user experience
- **Code Organization**: Restructured sign-up form validation logic for better readability and maintenance
- **Import Structure**: Updated package exports to include SignUpData model

### Fixed
- **KYC Validation Logic**: Fixed validation to properly handle KYC type switching between NRC and Passport
- **Null Safety**: Enhanced null safety handling for dropdown selections and form fields
- **Button State Management**: Fixed continue button state to properly reflect form validation status
- **Input Validation**: Added proper input formatters to prevent invalid data entry at source

## [0.0.2] (2025-09-22)

### Added
- Added self routing in signin page to otp page feature.

## [0.0.1] (2025-09-08)

### Added
- Initial release of the authentication UI package