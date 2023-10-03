//
//  SettingsViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Stored-Prop
    private var sections: [Section] = [Section]()
    
    // MARK: - UI Component
    private let tableView: UITableView = {
        
        let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Settings"
        
        view.backgroundColor = .systemBackground
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        view.addSubview(self.tableView)
        
        configureModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }
    
    private func configureModels() -> Void {
        
        sections.append(Section(
            title: "Profile",
            options: [Section.Option(
                title: "View Your Profile",
                handler: { [weak self] in
                    DispatchQueue.main.async {
                        self?.viewProfile()
                    }
                })]))
        
        sections.append(Section(
            title: "Account",
            options: [Section.Option(
                title: "Sign Out",
                handler: { [weak self] in
                    DispatchQueue.main.async {
                        self?.signOutTapped()
                    }
                })]))
    }
    
    private func viewProfile() -> Void {
        
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    private func signOutTapped() -> Void {}
}

// MARK: - Extension ViewController
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Methods
    ///  Required Methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model: Section.Option = sections[indexPath.section].options[indexPath.row]
        
        cell.textLabel?.text = model.title
        
        return cell
    }
    
    ///  Optional Methods.
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count    //  Default is 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let model: Section = sections[section]
        
        return model.title
    }
    
    // MARK: - UITableViewDelegate - (Optional) Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //  Call handler for cell.
        let model: Section.Option = sections[indexPath.section].options[indexPath.row]
        
        model.handler()
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct SettingsViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - (Required) Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        SettingsViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct SettingsViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            SettingsViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
