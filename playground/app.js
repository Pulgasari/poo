// app.js

// :::::: IMPORTS

// ::: aufbau
import aufbau, { html, useRef, useSignal, useSignalEffect, Fragment } from '@aufbau/kit';
window.html = html; aufbau.init();

// ::: poo
import compilePOO from '@poo/compiler';

// ::: misc

// ::: components
import Footer from './components/Footer.js';
import Header from './components/Header.js';


// Import: Highlight.js and POO language support
import hljs        from 'https://cdn.jsdelivr.net/npm/highlight.js@11.9.0/+esm';
import registerPoo from 'https://pulgasari.github.io/poo/js-packages/hljs/index.js';
hljs.registerLanguage('poo', registerPoo); // Register POO custom syntax

// Poo Example Code
const pooExample = await fetch('./example.poo').then((res) => res.text());

function transformCode (code) {
  try       { return compilePOO(code).code; } 
  catch (e) { return '// Compilation error:\n' + e.message; }
}

    function Main () {
      const input  = useSignal(pooExample);
      const output = useSignal('');
      const preOverlayRef = useRef(null);

      useSignalEffect(() => {
        const currentInput = input.value;
        const timer = setTimeout(() => { 
          output.value = transformCode(currentInput); 
        }, 300);

        return () => clearTimeout(timer);
      });

      // Synchronize scrolling between the transparent textarea and the code overlay
      const handleScroll = (e) => {
        if (preOverlayRef.current) {
          preOverlayRef.current.scrollTop  = e.target.scrollTop;
          preOverlayRef.current.scrollLeft = e.target.scrollLeft;
        }
      };

      // Generate highlighted HTML strings using Highlight.js
      const highlightedInput  = hljs.highlight(input.value || '', { language: 'poo' }).value;
      const highlightedOutput = output.value ? hljs.highlight(output.value, { language: 'javascript' }).value : '';

      return html`
        <div id='playground'>
          <!-- Input code editor container with visual overlay -->
          <div id='code-input'>
            <label>poo code</label>
            <div class='editor-wrapper'>
              <textarea
                id='code-input-area'
                placeholder='enter poo code ...'
                value=${input}
                onInput=${(e) => (input.value = e.target.value)}
                onScroll=${handleScroll}
                spellcheck="false"
              ></textarea>
              <pre ref=${preOverlayRef} class='code-overlay hljs'><code dangerouslySetInnerHTML=${{ __html: highlightedInput + '\n' }}></code></pre>
            </div>
          </div>

          <!-- JavaScript highlighted output container -->
          <div id='code-output'>
            <label>js output code</label>
            <pre class='hljs'><code dangerouslySetInnerHTML=${{ __html: highlightedOutput }}></code></pre>
          </div>
        </div>
      `;
    }

function App () {
  return html`<${Fragment}>
    <${Header}/>
    <div id='app-body'><${Main}/></div>
    <${Footer}/>
  </${Fragment}>`;
}   
    
const $body    = document.body;
const $app     = document.getElementById('app');
const $appBody = document.getElementById('app-body');

aufbau.render(html`<${App}/>`, $app);




