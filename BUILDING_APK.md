# Building APK with GitHub Actions

This project uses GitHub Actions to automatically build Android APK files without requiring Android Studio on your local machine.

## How It Works

The workflow (`.github/workflows/build-apk.yml`) automatically builds an APK when:
- You push code to `main` or `master` branch
- You create a pull request
- You manually trigger it from GitHub
- You create a new release

## How to Download the APK

### Method 1: From Workflow Runs (Most Common)

1. Go to your GitHub repository
2. Click on the **Actions** tab
3. Click on the latest workflow run (e.g., "Build Android APK")
4. Scroll down to the **Artifacts** section
5. Download `saathpay-release-apk`
6. Extract the ZIP file to get `app-release.apk`

### Method 2: Manual Trigger

1. Go to your GitHub repository
2. Click on the **Actions** tab
3. Click on **Build Android APK** workflow
4. Click **Run workflow** button (top right)
5. Select the branch and click **Run workflow**
6. Wait for the build to complete
7. Download the artifact as described in Method 1

### Method 3: From Releases (Recommended for Production)

1. Go to your GitHub repository
2. Click on **Releases** (right sidebar)
3. Click **Create a new release**
4. Create a tag (e.g., `v1.0.0`)
5. Fill in release details
6. Click **Publish release**
7. The APK will be automatically attached to the release

## Installing the APK on Android

1. Transfer the `app-release.apk` file to your Android device
2. Open the file on your device
3. If prompted, enable "Install from Unknown Sources" in Settings
4. Follow the installation prompts

## Workflow Configuration

The workflow:
- Uses Ubuntu latest runner
- Sets up Java 17 (required for Android builds)
- Sets up Flutter 3.24.5 (stable channel)
- Installs dependencies
- Builds release APK
- Uploads APK as artifact (kept for 30 days)
- Attaches APK to releases automatically

## Troubleshooting

### Build Fails
- Check the Actions tab for error logs
- Ensure all dependencies in `pubspec.yaml` are compatible
- Verify Flutter version compatibility

### Can't Install APK
- Enable "Install from Unknown Sources" in Android Settings
- Ensure the APK is not corrupted during download/transfer

### APK Not Available
- Wait for the workflow to complete (usually 3-5 minutes)
- Check if the workflow run was successful (green checkmark)

## Next Steps

To start building APKs:
1. Commit and push this workflow file to GitHub
2. The workflow will run automatically
3. Download the APK from the Actions tab

```bash
git add .github/workflows/build-apk.yml
git commit -m "Add GitHub Actions workflow for APK builds"
git push origin main
```
