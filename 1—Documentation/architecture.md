# NAS System Architecture

The NAS system consists of four layers:

Storage Layer
- External SSD connected through USB 3.0
- EXT4 filesystem

Management Layer
- OpenMediaVault web interface
- User permission management

Access Layer
- SMB network file sharing
- Web interface access

Security Layer
- Disk encryption (LUKS)
- SSH secure access
- Firewall rules

Data flows from client devices over the network to the Raspberry Pi, which manages storage through OpenMediaVault.
