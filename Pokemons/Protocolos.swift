//
//  Protocolos.swift
//  HttpRequest
//
//  Created by Mauro Juárez Zavaleta on 27/11/25.
//
protocol ViewGeneral {
    func setupView()
    func addSubviews()
    func setupConstraints()
}

protocol CustomCellDelegate: AnyObject {
    func labelTapped(in cell: CustomTableViewCell)
}
