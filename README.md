# The Code

<a href="https://apps.apple.com/kr/app/the-code-private-content/id6447828226"> <image src="https://www.pngkit.com/png/full/322-3225520_download-the-app-available-on-the-app-store.png" width=140 /> </a>

This repository is an open-source project that replicates "The Code" project.

As this project is a replica, it may not be buildable and some private data is masked.

# Feature

The Code is an iOS application made using SwiftUI and several open-source libraries.

This project aims to provide you with ideas about the SwiftUI-based architecture, application structure, and promote my libraries.

<table>
    <thead>
        <tr>
            <th> Library </th>
            <th> Description </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td> <a href="https://github.com/wlsdms0122/RVB"> RVB</a> </td>
            <td> Base architecture that describe inter-module communication. </td>
        </tr>
        <tr>
            <td> <a href="https://github.com/wlsdms0122/Compose"> Compose </a> </td>
            <td> UIViewController wrap view as SwiftUI view. </td>
        </tr>
        <tr>
            <td> <a href="https://github.com/wlsdms0122/Reducer"> Reducer </a> </td>
            <td> Async/await based state machine. </td>
        </tr>
        <tr>
            <td> <a href="https://github.com/wlsdms0122/Route"> Route </a> </td>
            <td> Convenience UIViewController route helper. </td>
        </tr>
        <tr>
            <td> <a href="https://github.com/wlsdms0122/JSToast"> JSToast </a> </td>
            <td> Customizable toast. </td>
        </tr>
        <tr>
            <td> <a href="https://github.com/wlsdms0122/Dyson"> Dyson </a> </td>
            <td> Networking layer. </td>
        </tr>
        <tr>
            <td> <a href="https://github.com/wlsdms0122/Storage"> Storage </a> </td>
            <td> Data storage layer. </td>
        </tr>        
    </tbody>
</table>

# Installation
Due to the masking of private data, it may not be possible to build the application.

However, if you still want to build and run this project, follow the below steps:

1. Clone the repository using the following command:
```
git clone https://github.com/username/open-the-code.git
```
2. Move to the project folder.
```
cd open-the-code
```
3. Run the Makefile to create the .xcworkspacedata and open the project.
```
./run-tool generate_content && xed .
```

# Notice
- This repository not fully reflects the origin repository.
- This repository may not reflect real-time updates with the origin repository.
- This repository may not be maintained with app version updates.
