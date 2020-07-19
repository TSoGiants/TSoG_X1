# TSoG X1

This repository is for the TSoG X1 Aircraft Project. The repository is used to develop the simulation and testing needed to aid the design of the aircraft. The goal of the simulation is to be able to accurately simulate the TSoG X1 Aircraft to be able to predict the performance, size the wings and tail, and set up a platform for further development of aerospace projects. 

The simulation is developed in Octave 5.2.

## Overview

The repository is broken up into three sections: Simulation, Testing, and Analysis.

### Simulation
`Simulation` is used to contain the code for running the simulation as well as any models used in the simulation.

### Testing
`Testing` is used to contain test cases and associated testing functions needed to run the test cases.

### Analysis
`Analysis` is used to contain any analysis work that is done using the simulation or for the simulation.

## How to Run the Simulation

Install Octave 5.2 on the machine you want to run the simulation on.

### Run the Simulation with the Default Settings

Navigate to the `Simulation` folder and run the following:

`Results = TSoG_X1_Sim.m`

This will run the simulation with the defaults and save the results to `Results`

### Run a specific Test Case

Navigate to the `Testing` folder and run any of the "Test Case" scripts.

This will run the specific test case and will plot the results.

## Development process

This section describes how to contribute to the Project

### 1 Select An Issue

First step is to look through the list of open issues that are not assigned to anyone. Read through the descriptions to understand what the task or problem is. Then when you find one that you would like to work on, assign it to yourself.

### 2 Create An Issue Branch

Next, create a branch for your issue using the following naming convention:

`#<Issue Number>_<Short_Name_Description>`

For example, here is a fake issue (99) about fixing the thrust model:

`#99_FixThrustModel`

### 3 Work On Issue Locally

After creating the branch on the repository, clone the repository to your machine that you will do the development work on. If you have already cloned the repository, `fetch` the changes from the repository and checkout the newly created branch.

During your development, please adhere to the standards found in the **Programming Standards** section.

You are welcome to make as many or as little commits as you want to your issue branch, however **each commit must contain an appropriate message that describes all the changes performed in the commit**. As a suggestion, it is easier to keep commits small and have more of them than to have large commits and have fewer.

If you would like to collaborate with others on the work, feel free to push the issue branches to the repository for visibility.

When you are finished working on the issue, push the final changes to the repository and being the Pull Request process.

### 4 Create A Pull Request

On the TSoG_X1 GitHub website, navigate to the Pull Requests (PR) tab and follow these steps:

1. Select "New Pull Request"
2. In the "compare" drop down, select the branch you want to merge into master
    * The "base" drop down should be "master"
3. GitHub will perform a check to see if you have any merge conflicts
    * If there are any merge conflicts proceed to section **4.1 Merge Conflicts** to resolve them
4. Do a careful check of the changes that are part of the PR:
    * Are there any new files that shouldn't be there?
    * Are the changes only the changes you want to include?
    * Are the changes correct?
    * If you answer no to any of the above, fix them and push the changes and start back at 1
5. If there are no more merge conflicts, press the "Create pull request" button and fill out a descriptive title and a summary of the changes in the text boxes.
6. Add the phrase "Closes #<issue number>" in the description to automatically link an issue this PR will close
7. When you are done and everything is checked and correct, assign at least one reviewer (if you are not sure add Raul Maldonado @TheGreatFez as the reviewer ) and then press "Create pull request"
8. The reviewers will receive notifications that their review is requested and they will proceed to add their comments or findings to the PR
9. If any changes are requested, simply work on the changes on your local machine and then push the branch to the repository
    * This will automatically update the PR with your changes
    * You must re-request a review after you have made your updates which can be done by pressing the circulation button under the "Reviewers" section at the top of the PR
10. When all reviewers have approved the PR, an admin will then perform the merge of the PR which will automatically close the linked issue(s)
11. Lastly, the associated branch for the PR will be deleted

### 4.1 Merge Conflicts

Merge conflicts occur when a file or piece of code has been changed by an earlier commit(s) and the new changes would overwrite those changes.

In order to address the merge conflicts, follow these steps:

1. On your local machine `checkout` and perform a `pull` on the "master" branch
2. Next, `checkout` the branch for your issue that you are trying to resolve merge conflicts and then merge in the "master" branch
    * This should cause some merge conflicts to appear
3. Open each file that has merge conflicts and read through the conflicting changes
    * If the file is a text file, it should note the changes with <<< and >>> to show sections of your changes and the older commits changes
    * If it is a binary file or otherwise cannot be read easily by Git, this will have to be a manual checking of the file using each version
4. To resolve each conflict, manually edit the file to select which changes to keep (
    * If necessary, discuss this with the author of the conflicting changes to make sure nothing is lost during the conflict resolution
5. After all merge conflicts have been resolved, commit all changes to your issue branch and push to the repository to continue the review process

## Programming Standards

The following is a set of some basic rules to help keep the formatting consistent across all scripts.

### General Script Standards

**Comments**
* Use the `#` symbol not the `%` symbol for all comments

* Use comments to describe what code is doing as you go. This will help clear up the code's intent to yourself and future users

**Variable Names**
* Use `UpperCamelCase` for structure and class names, `CAPITALIZED_WITH_UNDERSCORES` for constants, and `lowercase_separated_by_underscores` for other names

* Use capitalized letters for any abbreviations such as `RK4` or `RPM`

**Indentation**
* Use 2 spaces for indentation, no tabs

### Functions
* All functions must have a comment section at the beginning with the following:
  * Full title of the function
  * Brief overview of the function
  * If needed, an explanation of how to use the function
  * Sources (if any) used to develop the function
