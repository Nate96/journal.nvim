import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import { format } from 'date-fns';

export function activate(context: vscode.ExtensionContext) {

	console.log('Congratulations, your extension "jouro" is now active!');

   // If Journal/ NOT exits
   //    ask user to create dir
   //    if yes > create dir
   //    if no  > return
   // if file does NOT exsist create file
   // show file in current tab
	const day = vscode.commands.registerCommand('jouro.day', () => {
      const Journal: string = "~/plugins/Journal.nvim/Journal/"
      const formattedDate: string = format(new Date(), 'yyyy-MM-dd EEEE');
      const filePath = path.join(Journal , formattedDate);
      vscode.workspace.openTextDocument(filePath) });

   // if current file is in correct format
   //    read in all files and store them in an array
   //    find current file in array
   //    if file is not newests show files[i+1]
   //    else show "newest entry, can't jump forward"
   // else
   //   show "current file not in correct format"
	const forward = vscode.commands.registerCommand('jouro.forward', () => { });

   // if current file is in correct format
   //    read in all files and store them in an array
   //    find current file in array
   //    if file is not the oldest show files[i-1]
   //    else show "newest entry, can't jump forward"
   // else
   //   show "current file not in correct format"
	const backward = vscode.commands.registerCommand('jouro.backward', () => { });

   // For each entry in Journal Dir
   //    if entry file is empty delete
	const clean = vscode.commands.registerCommand('jouro.clean', () => { });
	
   // Get current file name
   // for each entry where entry is the current file
   // if entry has "# Monthly Log" so entry
	const monthlyLog = vscode.commands.registerCommand('jouro.montlyLog', () => { });

	context.subscriptions.push(forward, backward, clean, monthlyLog, day);
}

export function deactivate() {}
