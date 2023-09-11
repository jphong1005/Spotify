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
        self.title = "Settings"
        
        self.view.backgroundColor = .systemBackground
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        configureModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }
    
    private func configureModels() -> Void {
        
        sections.append(Section(strTitle: "Profile",
                                arrOptions: [Section.Option(strTitle: "View Your Profile", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        
        sections.append(Section(strTitle: "Account",
                                arrOptions: [Section.Option(strTitle: "Sign Out", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
        })]))
    }
    
    private func viewProfile() -> Void {
        
        let profileVC: ProfileViewController = ProfileViewController()
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func signOutTapped() -> Void {}
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Methods
    //  Required Methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model: Section.Option = sections[indexPath.section].arrOptions[indexPath.row]
        
        if #available(iOS 14.0, *) {
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            
            content.text = model.strTitle
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = model.strTitle
        }
        
        return cell
    }
    
    //  Optional Methods.
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count    //  Default is 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let model: Section = sections[section]
        
        return model.strTitle
    }
    
    // MARK: - UITableViewDelegate - (Optional) Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //  Call handler for cell.
        let model: Section.Option = sections[indexPath.section].arrOptions[indexPath.row]
        
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
