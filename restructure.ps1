cd c:\Users\Ahmed\OneDrive\Desktop\tickety\lib

# Move shared widgets to core
Move-Item -Path features\events\presentation\widgets\event_card.dart -Destination core\widgets\
Move-Item -Path features\events\presentation\widgets\event_info_row.dart -Destination core\widgets\

cd features

# Onboarding
New-Item -ItemType Directory -Force -Path onboarding\presentation\screens
New-Item -ItemType Directory -Force -Path onboarding\presentation\widgets
Move-Item -Path auth\presentation\screens\splash_screen.dart -Destination onboarding\presentation\screens\
Move-Item -Path auth\presentation\screens\onboarding_screen.dart -Destination onboarding\presentation\screens\

# SignIn
New-Item -ItemType Directory -Force -Path signin\presentation\screens
New-Item -ItemType Directory -Force -Path signin\presentation\widgets
Move-Item -Path auth\presentation\screens\sign_in_screen.dart -Destination signin\presentation\screens\
Move-Item -Path auth\presentation\widgets\auth_header.dart -Destination signin\presentation\widgets\

# SignUp
New-Item -ItemType Directory -Force -Path signup\presentation\screens
New-Item -ItemType Directory -Force -Path signup\presentation\widgets
Move-Item -Path auth\presentation\screens\sign_up_screen.dart -Destination signup\presentation\screens\

# Forgot Password
New-Item -ItemType Directory -Force -Path forgotpassword\presentation\screens
New-Item -ItemType Directory -Force -Path forgotpassword\presentation\widgets
Move-Item -Path auth\presentation\screens\forgot_password_screen.dart -Destination forgotpassword\presentation\screens\

# Remove Auth
Remove-Item -Path auth -Recurse -Force

# Home
New-Item -ItemType Directory -Force -Path home\presentation\screens
New-Item -ItemType Directory -Force -Path home\presentation\widgets
Move-Item -Path events\presentation\screens\home_screen.dart -Destination home\presentation\screens\
Move-Item -Path events\presentation\widgets\home_header.dart -Destination home\presentation\widgets\
Move-Item -Path events\presentation\widgets\categories_bar.dart -Destination home\presentation\widgets\
Move-Item -Path events\presentation\widgets\invite_banner.dart -Destination home\presentation\widgets\

# Map
New-Item -ItemType Directory -Force -Path map\presentation\screens
New-Item -ItemType Directory -Force -Path map\presentation\widgets
Move-Item -Path events\presentation\screens\map_explore_screen.dart -Destination map\presentation\screens\

# Event Details
New-Item -ItemType Directory -Force -Path event-details\presentation\screens
New-Item -ItemType Directory -Force -Path event-details\presentation\widgets
Move-Item -Path events\presentation\screens\event_details_screen.dart -Destination event-details\presentation\screens\
Move-Item -Path events\presentation\widgets\event_header_image.dart -Destination event-details\presentation\widgets\
Move-Item -Path events\presentation\widgets\event_about_section.dart -Destination event-details\presentation\widgets\
Move-Item -Path events\presentation\widgets\organizer_row.dart -Destination event-details\presentation\widgets\
Move-Item -Path events\presentation\widgets\bottom_cta_bar.dart -Destination event-details\presentation\widgets\
Move-Item -Path events\presentation\widgets\going_bar.dart -Destination event-details\presentation\widgets\
