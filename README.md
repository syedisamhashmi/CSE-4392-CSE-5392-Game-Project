# CSE-4392-CSE-5392-Game-Project

Video Game Design Project for CSE-4392 / CSE-5392

Team Members

- Syed Isam Hashmi
- Eric Kressler
- Natraj Hullikunte
- Sundeep Kumar Gurrapusala
- Balamurale Balusamy Siva

Technologies Used

- Godot v3.3.3
- LaTeX

# Tooling

## OSX

---

### LaTeX

1. In order to format LaTeX files on , you must install [MaxTeX](http://www.tug.org/mactex/).

> As per personal preferences, VS Code is my IDE of choice.
> As a result of this, an extension for LaTeX is suggested
> for the workspace (james-yu.latex-workshop). This should appear
> when opening VS Code.

2. In order to format \*.tex files through VS Code (without error), you must also must run `brew install latexindent`

---

<br/>
<br/>

# Operating System Agnostic

### Formatters

Prettier is suggested for automatic formatting of
files in order to prevent user preference from becoming
a cause for merge conflicts.

> As per personal preferences, VS Code is my IDE of choice.
> As a result of this, an extension for Prettier is suggested
> for the workspace (esbenp.prettier-vscode). This should appear
> when opening VS Code.

---

<br/>
<br/>

# Repository Layout

- Meetings_And_Attendance
  - Weekly meetings attendance and timestamps of
    users who joined for auditing purposes
- Project Proposal
  - LaTeX files used during the process of
    writing up our project proposal
- Team_H_Project
  - The Godot source code used to build and run the team video game.
- Sources_And_Credits.xlsx
  - References to any and all assets as well as where they originated from.

# CSE-4392-Game-Project

Make changes in your IDE.

Make a feature/** or bugfix/** branch (git branch feature/adding-icon)

Checkout that branch (git checkout feature/adding-icon)

(OR DO BOTH AT ONCE! :D ) ((git checkout -b feature/adding-icon))

Stage the changes you would like to commit. (Selecting which files you would like to create a snapshot of) (git stage ./icon.png) (git stage --all)

Commit those changes. (Creating the snapshot) (git commit -m "your message here")

Push (push them up to github) (git push)

Push the branch ( git push --set-upstream origin feature/\*\* )

Create the Pull-Request (PR)

Notify your team, have them review your code.

Once the admin of the team approves your work, it gets merged.

It's now in the develop branch
