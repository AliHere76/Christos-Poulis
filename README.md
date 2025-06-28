<body>
  <div class="section">
    <h1>A Personal Branding Fitness App</h1>
    <h2>Overview</h2>
    <p>Christos Poulis is a Flutter-based mobile application designed to help users create and manage their fitness profiles. The app integrates Firebase Authentication for secure user management and provides a responsive user interface that adapts to different device types (mobile, tablet, and desktop).</p>
    <h2>Features</h2>
    <ul>
      <li><strong>User Authentication</strong>: Supports email/password sign-up and sign-in, as well as Google Sign-In.</li>
      <li><strong>Profile Management</strong>: Users can set up their profiles with details such as name, role, weight, height, gender, and date of birth.</li>
      <li><strong>Responsive Design</strong>: Adapts seamlessly to different screen sizes using a custom responsive framework.</li>
      <li><strong>State Management</strong>: Utilizes Riverpod for efficient state management across the app.</li>
      <li><strong>Real-time Feedback</strong>: Displays success and error messages using a custom notifier system.</li>
    </ul>
    <h2>Project Structure</h2>
    <p>The project follows a clean architecture pattern with the following key components:</p>
    <ul>
      <li><strong>/lib/models</strong>: Contains data models, such as <code>User</code>.</li>
      <li><strong>/lib/providers</strong>: Manages providers for authentication state and services using Riverpod.
        <ul>
          <li><code>auth_providers.dart</code>: Defines providers for Firebase authentication and user state.</li>
          <li><code>auth_controller.dart</code>: Handles authentication logic (sign-up, sign-in, sign-out, profile setup).</li>
        </ul>
      </li>
      <li><strong>/lib/screens</strong>: Contains UI screens.
        <ul>
          <li><code>signup_page.dart</code>: Implements the sign-up screen with responsive layouts for mobile, tablet, and desktop.</li>
        </ul>
      </li>
      <li><strong>/lib/services</strong>: Includes service classes for interacting with Firebase.
        <ul>
          <li><code>auth_service.dart</code>: Manages Firebase Authentication operations.</li>
        </ul>
      </li>
      <li><strong>/lib/utils</strong>: Utility classes for responsive design and notifiers.
        <ul>
          <li><code>responsive_extension.dart</code>: Provides extensions for responsive sizing.</li>
          <li><code>responsive_helper.dart</code>: Helper functions for responsive values.</li>
          <li><code>responsive_widget.dart</code>: Custom widget for responsive layout building.</li>
          <li><code>message_type.dart</code>: Enum for notifier types (success, error).</li>
        </ul>
      </li>
      <li><strong>/lib/widgets</strong>: Reusable UI components.
        <ul>
          <li><code>app_message_notifier.dart</code>: Custom notifier system for displaying messages.</li>
        </ul>
      </li>
    </ul>
    <h2>Prerequisites</h2>
    <ul>
      <li><strong>Flutter</strong>: Version 3.0.0 or higher</li>
      <li><strong>Dart</strong>: Version 2.17.0 or higher</li>
      <li><strong>Firebase Account</strong>: Set up a Firebase project with Authentication enabled (Email/Password and Google Sign-In).</li>
      <li><strong>Dependencies</strong>:
        <ul>
          <li><code>firebase_auth</code></li>
          <li><code>flutter_riverpod</code></li>
          <li>Other dependencies as listed in <code>pubspec.yaml</code>.</li>
        </ul>
      </li>
    </ul>
    <h2>Setup Instructions</h2>
    <ol>
      <li><strong>Clone the Repository</strong>:
        <pre><code>git clone https://github.com/AliHere76/Christos-Poulis;
cd fitness-journey</code></pre>
      </li>
      <li><strong>Install Dependencies</strong>:
        <p>Run the following command to install all required packages:</p>
        <pre><code>flutter pub get</code></pre>
      </li>
      <li><strong>Configure Firebase</strong>:
        <ul>
          <li>Set up a Firebase project in the <a href="https://console.firebase.google.com/" target="_blank">Firebase Console</a>.</li>
          <li>Enable Email/Password and Google Sign-In providers in the Authentication section.</li>
          <li>Download the <code>google-services.json</code> (for Android) or <code>GoogleService-Info.plist</code> (for iOS) and place them in the appropriate directories (<code>android/app</code> or <code>ios/Runner</code>).</li>
          <li>Update <code>android/build.gradle</code> and <code>android/app/build.gradle</code> with Firebase configurations as per the Firebase setup guide.</li>
        </ul>
      </li>
      <li><strong>Run the App</strong>:
        <p>Start the app on an emulator or physical device:</p>
        <pre><code>flutter run</code></pre>
      </li>
    </ol>
    <h2>Usage</h2>
    <ul>
      <li><strong>Sign Up</strong>: Navigate to the sign-up screen to create a new account using an email and password. After successful registration, users are redirected to a profile setup screen.</li>
      <li><strong>Sign In</strong>: Existing users can sign in using email/password or Google Sign-In.</li>
      <li><strong>Profile Setup</strong>: After signing up, users can complete their profile with personal details.</li>
      <li><strong>Responsive UI</strong>: The app automatically adjusts its layout based on the device type (mobile, tablet, or desktop).</li>
    </ul>
    <h2>Key Dependencies</h2>
    <ul>
      <li><code>firebase_auth</code>: For user authentication with Firebase.</li>
      <li><code>flutter_riverpod</code>: For state management.</li>
      <li><code>flutter</code>: Core Flutter framework for building the UI.</li>
    </ul>
    <h2>Contributing</h2>
    <p>Contributions are welcome! Please follow these steps:</p>
    <ol>
      <li>Fork the repository.</li>
      <li>Create a new branch (<code>git checkout -b feature/your-feature</code>).</li>
      <li>Make your changes and commit (<code>git commit -m "Add your feature"</code>).</li>
      <li>Push to the branch (<code>git push origin feature/your-feature</code>).</li>
      <li>Create a pull request.</li>
    </ol>
    <h2>License</h2>
    <p>This project is licensed under the MIT License. See the <a href="LICENSE">LICENSE</a> file for details.</p>
    <h2>Contact</h2>
    <p>For any inquiries or issues, please open an issue on the repository or contact the project maintainer.</p>
  </div>
</body>
