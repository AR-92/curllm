# Instructions to push to GitHub

# 1. First, create a new repository on GitHub:
#    - Go to https://github.com/new
#    - Create a new repository named "curllm"
#    - Don't initialize with a README, .gitignore, or license

# 2. Then run these commands in your terminal:
git remote add origin https://github.com/yourusername/curllm.git
git branch -M main
git push -u origin main

# If you get an authentication error, you may need to:
# 1. Use GitHub CLI: gh auth login
# 2. Or set up a personal access token

# Alternative using GitHub CLI (if installed):
# gh repo create curllm --public --source=. --remote=origin
# git push -u origin main