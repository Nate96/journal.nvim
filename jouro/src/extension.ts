import * as vscode from 'vscode';

export function activate(context: vscode.ExtensionContext) {

	console.log('Congratulations, your extension "jouro" is now active!');

	const forward = vscode.commands.registerCommand('jouro.forward', () => { });

	const backward = vscode.commands.registerCommand('jouro.backward', () => { });

	const clean = vscode.commands.registerCommand('jouro.clean', () => { });
	
	const monthlyLog = vscode.commands.registerCommand('jouro.montlyLog', () => { });

	context.subscriptions.push(forward, backward, clean, monthlyLog);
}

export function deactivate() {}
